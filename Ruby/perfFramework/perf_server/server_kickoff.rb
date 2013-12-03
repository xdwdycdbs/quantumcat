require 'config'

`rm -f ./logs/*`

#parameters
agent_count = $agent_list.count
tds_count = $tds_list.count
account_count = $account_list.count
agent_dir=$agent_dir
case_no = ARGV[1].to_i

account_range = account_count / agent_count

#load cases
cases = []

f = File.open("cases", 'r')
f.each do |line|
    cases << line.split(':')[1]
end

fields = cases[case_no - 1].split(' ')

#if put,file_size or data_source
=begin
if fields[0] == 'put'
	data_source = "/vbidata"
	$agent_list.each do |agent|
		`scp #{data_source}/* ycai@#{agent}:/home/ycai/yxt/lightweight-perf/perf_server/vbidata/`
	end
end
=end

#let agents run jobs
agent_count.times do |i|
  account_start = i * account_range
  account_end = (i + 1) * account_range
  account_end = account_count - 1 if (account_end > account_count)
  cmd = nil

  agent = $agent_list[i]
  if fields[0] == 'get'
     cmd = "dsh -m #{agent} -c \"cd #{agent_dir};ruby client_job.rb #{account_start} #{account_range} #{fields[0]} #{fields[1]} #{fields[2]} #{fields[3]} #{fields[4]} #{ARGV[0]}\">result/myout &"
  elsif fields[0] == 'put'
     if fields[4].to_i == 0
        cmd = "dsh -m #{agent} -c \"cd #{agent_dir};ruby client_job.rb #{account_start} #{account_range} #{fields[0]} #{fields[1]} #{fields[2]} #{fields[3]} #{fields[4]} #{fields[5]} #{fields[6]} #{ARGV[0]}\">result/myout &"
     else
        cmd = "dsh -m #{agent} -c \"cd #{agent_dir};ruby client_job.rb #{account_start} #{account_range} #{fields[0]} #{fields[1]} #{fields[2]} #{fields[3]} #{fields[4]}  #{fields[5]} #{fields[6]} #{fields[7]} #{ARGV[0]}\">result/myout &"
     end
  elsif fields[0] == 'delete'
     cmd = "dsh -m #{agent} -c \"cd #{agent_dir};ruby client_job.rb #{account_start} #{account_range} #{fields[0]} #{fields[1]} #{fields[2]} #{fields[3]} #{fields[4]} #{ARGV[0]}\">result/myout &"
  elsif fields[0] == 'mkdir'
     cmd = "dsh -m #{agent} -c \"cd #{agent_dir};ruby client_job.rb #{account_start} #{account_range} #{fields[0]} #{fields[1]} #{fields[2]} #{fields[3]} #{ARGV[0]}\">result/myout &"
  end

  puts cmd
  `#{cmd}`
end

`ruby listen.rb #{ARGV[0]}`
