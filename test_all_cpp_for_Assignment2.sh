#！/bin/bash

# 注意这里所有的路径全部都是相对于本脚本的路径
# 本脚本由 BEng B24 Byron Ding 编写
echo "开始执行"

cpp_compile_setting_command="g++ -pedantic-errors -std=c++11"

my_cpp_files_path_folder="./my_codes/"
list_all_my_cpp_files_command="ls "${my_cpp_files_path_folder}

###################### 需要修改
# 正则表达式，筛选符合条件的文件，一位数字，然后以c或cpp结尾
my_cpp_filename_regrex="Number-([A-Z])\.cpp"

# echo $list_all_my_cpp_files_command
# 正则表达式，筛选符合条件的文件，一位数字，然后以cpp结尾
# 注意，正则表达式不可包含 \d 用于匹配数字
# 因为未知原因（没搞明白），为什么无法匹配成功
my_cpp_files="$( ${list_all_my_cpp_files_command} | grep -E ${my_cpp_filename_regrex} )"
# echo ${my_cpp_files}


echo ${my_cpp_files}

# 因为是按照文件名来测试的，所以不用担心多余的遍历从而报错
for my_cpp_file in ${my_cpp_files}
do
	
	# 如果符合规范（老师给的命名要求）
	if [[ ${my_cpp_file} =~ ${my_cpp_filename_regrex} ]]
	then
		task_number=${BASH_REMATCH[1]}
	fi
	
	echo ${task_number}
	
	# 编译C++文件（没有C文件）
	if [[ "${task_number}" == "D" ]]
	then
			complie_command=${cpp_compile_setting_command}" "${my_cpp_files_path_folder}${my_cpp_file}" "${my_cpp_files_path_folder}"function.cpp -o "${my_cpp_files_path_folder}"compiled_"${task_number}".exe"
	else
		complie_command=${cpp_compile_setting_command}" "${my_cpp_files_path_folder}${my_cpp_file}" -o "${my_cpp_files_path_folder}"compiled_"${task_number}".exe"
	fi
	

	echo ${complie_command}
	# 编译
	echo `${complie_command}`

	# 找到对应的测试文件夹
	corresponding_folder_path="./sample_case/"${task_number}"/"
	
	# 获取一共有多少测试文件
	# 文件列表 （全信息） | 去除文件夹 | 匹配后缀 in | 数行数（文件数）
	number_of_input_and_output_files=`ls -l ${corresponding_folder_path} | grep "^-" | grep -E "${task_number}-([0-9]*).in" | wc -l`
	# echo $file_numbers
	# 已经废除 # 其中一半是输入，一半是输出

	index=1
	while ((${index} <= $number_of_input_and_output_files))
	do
		#echo $index
		# 每一个自己输出的文件的文件名（文件路径）
		each_myoutput_path=${corresponding_folder_path}${task_number}"-"${index}".myoutput.txt"

		# 如果自己的文件不存在，创建文件
		if [ -e ${each_myoutput_path} ]
		then
			touch ${each_myoutput_path}
		fi
		
		# input 的文件名
		each_input_file_name=${task_number}"-"${index}".in"
		
		# output 的文件名
		each_output_file_name=${task_number}"-"${index}".out"
		
		# input 的文件名 （文件路径）
		each_input_file_path="${corresponding_folder_path}${each_input_file_name}"
		
		# output 的文件名 （文件路径）
		each_output_file_path="${corresponding_folder_path}${each_output_file_name}"
		
		# 可执行文件路径
		excute_file_path=${my_cpp_files_path_folder}"compiled_"${task_number}".exe"
		# 输入文件到可执行文件，输出结果储存到自己的文件
		${excute_file_path} < ${each_input_file_path} > ${each_myoutput_path}
		
		# echo $each_myoutput_path
		# temp="diff "${each_output_file_path}" "${each_myoutput_path}
		
		# echo $temp
		# diff "${each_output_file_path}" "${each_myoutput_path}"
		compare_command="diff -w "${each_output_file_path}" "${each_myoutput_path}
		
		echo ${compare_command}
		
		compare_result=`${compare_command}`
		
		# 打印文件名 input output
		# -e 开启特殊字符转义
		# …… 会自动转成中文的省略号
		echo -e "正在测试中……"
		echo -e "需要编译的文件："${my_c_cpp_file}
		echo -e "\t样例输入文件："${each_input_file_name}
		echo -e "\t样例输出文件："${each_output_file_name}
		# 打印结果
		echo "结果如下："
		echo $compare_result
		# 打印结果是否为空
		echo "结果是否为空："
		if [ "${compare_result}" == "" ]
		then
			echo -e "\tempty：True"
		fi
		# 分割题目打印结果
		echo "——————————————————————"
		# if [ "${compare_result}" == "" ]
		# then
		# 	echo "true"
		# fi
		let "index++"
	done
	# 打印横线，这样，每个c/cpp文件测试完成之后会用双横线分割（包括前面的横线）
	echo "——————————————————————"
done
