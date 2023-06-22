# rm -rf * .*                           # Delete All
# git branch --delete branchname        # Delete local branch
# git push origin --delete branchname   # Delete remote branch
# git reset --hard HEAD~1               # Delete last commit

ls -lA  | grep ^d | awk '{print $9}'    # Print all Folder
ls -la  | grep ^- | awk '{print $9}'    # Print all File
start ~/AppData/Roaming/Code/User       # VSCode Reset

# Rename files in directory as numbers
# find -maxdepth 1 -type f | cat -n | while read n f; do mv -n "$f" "${n}.jpg"; done

# Remove values after _ for obj in folder
# for obj in * ; do echo mv -v "$obj" "${obj#*_}"; done

history

bash reset.sh && bash run.sh
bash reset.sh
bash run.sh

