# Runs the end to end LORELEI English EDL
mvn compile
cpath="./target/dependency/*:./target/classes/"

ILCODE=10
TA_IN_DIR="/shared/corpora/corporaWeb/lorelei/evaluation-2018/il10/processed/setS/"
TA_OUT_DIR="/shared/preprocessed/cddunca2/lorelei/il10/setS/"
SUBMISSION="/shared/experiments/cddunca2/lorelei/submission-purgatory/il10_setS.tab"

java -classpath  ${cpath} -Xmx16g -Dfile.encoding=UTF-8 edu.illinois.cs.cogcomp.loreleiengedl.apps.LORELEI2018 ner \
    ${TA_IN_DIR} ${TA_OUT_DIR}

cd neural-el
python neuralel_tadir.py --mode=ta --model_path=/shared/bronte/ngupta19/neural-el_resources/models/CDT.model \
    --tadirpath=${TA_OUT_DIR}\
    --taoutdirpath=${TA_OUT_DIR}

cd ..

java -classpath  ${cpath} -Xmx16g -Dfile.encoding=UTF-8 edu.illinois.cs.cogcomp.loreleiengedl.apps.LORELEI2018 \
nomlink ${TA_OUT_DIR} 
java -classpath  ${cpath} -Xmx16g -Dfile.encoding=UTF-8 edu.illinois.cs.cogcomp.loreleiengedl.apps.LORELEI2018 \
submission ${TA_OUT_DIR} ${SUBMISSION} ${ILCODE}
