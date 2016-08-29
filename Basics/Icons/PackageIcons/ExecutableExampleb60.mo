within ClaRa.Basics.Icons.PackageIcons;
model ExecutableExampleb60

  annotation (Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAZIAAAGRCAYAAABPFjVUAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAP1QAAD9UBqc2dtgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAA4uSURBVHic7d3pj50Hecbh+z0z4y1eZnfixLtA0LKFJQRBQhZhx/nE/1WkAqW0KbQIKlRVqItUqZvafmhF2xAcJ3YSSIKTseN9nxmv8XjefrBDkUoD8TOes8x1/QXPhzn6zZz3nnOaubm5I0k2BQA+uNnh3I6IkABwVzrdPgCA/iYkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAiZAAUCIkAJQICQAlQgJAyXC3D3jP3755Oi+fmev2GQB94ZPTG/PVD23u9hlJeigk1xduZf7dhW6fAdAXri/c6vYJv+StLQBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoKRnvo9kKTy8eWMe3TLW7TMA3tePj13MwbOD80V+AxWSsTUj2T26rttnALyvV87Nd/uEJeWtLQBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREgBKhASAEiEBoERIACgREpbF2as3srDYdvsM4B4Y7vYBrAz/duR8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sGI1ST4xtSH7dk1n0hIL7pqQsOIstsmHx9blmV1T2bFpXbfPgb4nJKwY7y2x9uycyu9OWWLBUhESBl6bZGz1nSXWltEMWWLBkhISBtra4U4ee3A8T26fyMiQJRbcC0LCQBpumnz2/k15ZtdU1q/yYw73klcYA+cTk+uzb/d0ptat7vYpsCIICQNhsU0+NLou+3ZbYsFyExL62mLbZsv6299O+DFLLOgKIaEvtUnGVg3nqR0T+fyWMUss6CIhoe+sGerkSw+N56ntE1lliQVdJyT0jaFOk8/dvyl7d05lgyUW9AyvRnpem+Tjk+vz7O7pTFtiQc8REnpW27bZPbouz+yazq5RSyzoVUJCz7m9xFqdPTum8vHpjZZY0OOEhJ7RJhldPZyntk3k0QctsaBfCAk9YfVQJ196cCxP75i0xII+IyR01VCTO5+JNW2JBX3KK5fuaNt87M63E26+zxIL+pmQsKwW31ti7ZzO7jFLLBgEQsKyWEyyed2q7Nk5mU9Mb7LEggEiJCyLp7dPZGzNqgx1JAQGjZCwLCb9RzoMLDtLAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBESAEqEBIASIQGgREgAKBnu9gFL6eL1mzl86Wq3zwB4X7PXF7p9wpIaqJAcOD2XA6fnun0GwIrirS0ASoQEgBIhAaBESAAoERIASoQEgBIhAaBESAAoERIASoQEgBIhAaBESAAoERIASoQEgBIhAaCkZ76PZM3wUDas6plzAHramuGhbp/wS83c3NylJJu6fQgAfWnWW1sAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQIiQAlAgJACVCAkCJkABQMpxktttHANC3Zv8HFSiRsqsgN14AAAAASUVORK5CYII=",
          fileName=
              "modelica://ClaRa/figures/Packages/ExecutableExample_b60.png")}));

end ExecutableExampleb60;
