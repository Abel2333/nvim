local M = {}

-- Open file with system tools
function M.system_open(state)
    local node = state.tree:get_node()
    local path = node:get_id()
    vim.ui.open(path)
end

-- Try to move left in file tree smartly
function M.smart_left(state)
    local node = state.tree:get_node()
    if node.type == 'directory' and node:is_expanded() then
        if state.name == 'filesystem' then
            require('neo-tree.sources.filesystem.commands').toggle_node(state)
        else
            require('neo-tree.sources.common.commands').toggle_node(state)
        end
    else
        require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
    end
end

-- Try to move right in file tree smartlly
function M.smart_right(state)
    local node = state.tree:get_node()
    if node.type == 'directory' then
        if not node:is_expanded() then
            if state.name == 'filesystem' then
                require('neo-tree.sources.filesystem.commands').toggle_node(state)
            else
                require('neo-tree.sources.common.commands').toggle_node(state)
            end
        elseif node:has_children() then
            require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
        end
    elseif node.type == 'file' then
        require('neo-tree.sources.common.commands').open(state, function() end)
    end
end

return M
