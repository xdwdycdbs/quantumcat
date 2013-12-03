require 'config'

`rm -rf perf*log`

#parameters
@account_start = ARGV[0].to_i
@account_range = ARGV[1].to_i
@operation = ARGV[2]
@prefix = ARGV[3]
@count = ARGV[4]
@depth = ARGV[5]
@folder_syzygy = ARGV[6]
@resumable = ARGV[7]
@filesize = ARGV[8]
@datasource = ARGV[9]
@accounts = $account_list

#send PUT/GET to Trogdor concurrently
@accounts.slice(@account_start,@account_range).each_with_index do |account, index|
    tdsIndex = index % $tds_list.count
    system("ruby kick.rb #{@operation} #{account[0]} #{account[1]} #{account[2]} #{@prefix} #{@count} #{@depth} #{@folder_syzygy} #{@resumable} #{@filesize} #{@datasource} #{tdsIndex} #{ARGV[ARGV.length - 1]} &") 
end
