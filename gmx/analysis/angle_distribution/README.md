echo -e "a OW or a NA\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f ../nvt-production.gro
echo '8' | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o test.gro -pbc nojump -b 0 -e 10000 -n ./index.ndx
python angle_distribution.py ./data/test.gro ./data/a.csv ./data/a.mat NA theta
