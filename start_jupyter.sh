#~/bin/bash

jupyter notebook \
    --no-browser \
    --NotebookApp.allow_origin=\'$(gp url 8888)\' \
    --NotebookApp.notebook_dir=my_notebooks \
    2>&1 \
  | tee .jupyter_log.log &

echo "CHECKING";
J_TOKEN="";
for WAIT in `seq 1 30`; do
  echo "TOKEN-TESTING ${WAIT}";
  J_TOKEN=`grep token .jupyter_log.log | awk -F= '{print $2}' | head -n 1`
  if [ -n "${J_TOKEN}" ]; then
    echo "FOUND/LEAVING";
    break;
  fi
  echo "SLEEPING";
  sleep 0.5;
done

if [ -n "${J_TOKEN}" ]; then
  echo "TOKEN WAS FOUND";
  JUPYTER_URL="$(gp url 8888)/notebooks/my_notebook.ipynb?token=${J_TOKEN}"
  echo -e "\n\n\n\n\n\t\t** OPENING NOTEBOOK IN NEW TAB. PLEASE CHECK YOUR POP-UP BLOCKER **\n";
  gp preview --external "${JUPYTER_URL}";
else
  echo "Could not start Jupyter successfully.";
  exit 1;
fi
