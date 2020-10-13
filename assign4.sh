for file in $(ls $1); do
    num=$(gawk '{if(NR==5) print $0}' $1/$file)
    if [ $num -gt 50 ]; then
        cls="$cls $file"
    fi
done

if [ $# -gt 4 ]; then
    lSym='\'$5
    rSym='\'$6
else
    lSym='\[\['
    rSym='\]\]'
fi

for class in $cls; do
    dept_code=$(gawk '{if(NR==1) print $1; exit}' $1/"$class")
    dept_name=$(gawk '{if (NR==1) print $2; exit}' $1/"$class")
    course_name=$(gawk '{if (NR==2) {print $0; exit}}' $1/"$class")
    course_start=$(gawk '{if (NR==3) {print $2; exit}}' $1/"$class")
    sMonth=$(echo $course_start | gawk 'BEGIN {FS = "/"} {print $1}')
    sDay=$(echo $course_start | gawk 'BEGIN {FS = "/"} {print $2}')
    sYear=$(echo $course_start | gawk 'BEGIN {FS = "/"} {print $3}')
    course_end=$(gawk '{if (NR==3) {print $3; exit}}' $1/"$class")
    eMonth=$(echo $course_end | gawk 'BEGIN {FS = "/"} {print $1}')
    eDay=$(echo $course_end | gawk 'BEGIN {FS = "/"} {print $2}')
    eYear=$(echo $course_end | gawk 'BEGIN {FS = "/"} {print $3}')
    credit_hours=$(gawk '{if (NR==4) {print $0; exit}}' $1/"$class")
    num_students=$(gawk '{if (NR==5) {print $0; exit}}' $1/"$class")
    course_num=$(echo $1/"$class" | sed -E 's/[^0-9]//g')
    month=$(echo $3 | gawk 'BEGIN {FS = "/"} {print $1}')
    day=$(echo $3 | gawk 'BEGIN {FS = "/"} {print $2}')
    year=$(echo $3 | gawk 'BEGIN {FS = "/"} {print $3}')

    cp $2 temp
    sed -i "s/$lSym""dept_code$rSym/$dept_code/g" temp
    sed -i "s/$lSym""dept_name$rSym/$dept_name/g" temp
    sed -i "s/$lSym""course_name$rSym/$course_name/g" temp
    sed -i "s/$lSym""course_start$rSym/$sMonth\/$sDay\/$sYear/g" temp
    sed -i "s/$lSym""course_end$rSym/$eMonth\/$eDay\/$eYear/g" temp
    sed -i "s/$lSym""credit_hours$rSym/$credit_hours/g" temp
    sed -i "s/$lSym""num_students$rSym/$num_students/g" temp
    sed -i "s/$lSym""course_num$rSym/$course_num/g" temp
    sed -i "s/$lSym""date$rSym/$month\/$day\/$year/g" temp
    if [ ! -d $4 ]; then
        mkdir $4
    fi
    cp temp "$4/$dept_code$course_num".warn
    rm temp
done

