require 'config'

#scp logs
$agent_list.each do |agent|
    `scp #{agent}:/home/ycai/lightweight-perf/perf_agent/perf*com.log logs`
end

#begin to analyse logs
totalTime=0

#calc the total time for all request
Dir.open("logs").each do |f|
	log=File.open("logs/" + f)
	if !File.directory?(log)
		log.each do |line|
			field_arr = line.split("|")
			totalTime = totalTime+field_arr[field_arr.length - 1].to_f
		end
	end
end

#count
totalCount=`cd logs;grep \"|\" perf*.log | wc -l`
successCount=`cd logs;grep \"|Success|\" perf*.log | wc -l`
errorCount=`cd logs;grep \"|Fail|\" perf*.log | wc -l`

#generate the report
reportFile=File.open("result/report",'w')
reportFile.puts("average Response Time:"+(totalTime/totalCount.to_i).to_s+"s\n"+"total Count:"+totalCount+"success Count:"+successCount+"error Count:"+errorCount)
reportFile.close
