for chunk = 0, 65535 do
    report_file_name = string.format('output/report-%04x.txt', chunk)
    hint_file_name = string.format('output/report-%04x.hint', chunk)
    if os.execute('test -e ' .. report_file_name) then
        hint_file = io.open(hint_file_name, 'w+')
        assert(hint_file)
        report_file = io.open(report_file_name, 'r')
        assert(report_file)
        for line in report_file:lines() do
            _, _, seed = string.find(line, "(%d+)")
            hint_file:write(string.format('%d\n', seed))
        end
        report_file:close()
        hint_file:close()
    end
end
