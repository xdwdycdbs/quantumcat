$account_list = []
@account_src = ARGV[0]
@f = nil

if @account_src == '0-99'
   @f = File.new("accounts_src/perfuser0-99.txt", "r")
elsif @account_src == '0-199'
   @f = File.new("accounts_src/perfuser0-199.txt", "r")
elsif @account_src == '200-299'
   @f = File.new("accounts_src/perfuser200-299.txt", "r")
end

@f.each do |line|
   md = /^([0-9]+) ([^:]+):(.+)$/.match(line)
   $account_list << [md[2], md[3], md[1]]
end 
@f.close

$agent_dir = '~/lightweight-perf/perf_agent'                                                                                                                      
$agent_list = ['injector01','injector02','injector03','injector04','injector05','injector06','injector07','injector08','injector09','injector10']
$tds_list = ['tds04.qa10']
