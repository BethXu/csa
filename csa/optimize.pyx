from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

cimport cython
from cpython cimport array
import math
import array
import random

try:
    xrange
except NameError:
    xrange = range


def calculate_exp(int n_probes,
                  current_energies,
                  cool,
                  double tacc,
                  double max_energy):
    cdef array.array exp_terms = array.array('d', [])
    cdef array.array exp_terms2 = array.array('d', [])
    for i in xrange(n_probes):
        E = current_energies[i]
        exp_term = math.exp((E - max_energy) / tacc)
        exp_terms.append(exp_term)
        if cool:
            exp_term = math.exp(2.0 * (E - max_energy) / tacc)
            exp_terms2.append(exp_term)
    exp_terms.tolist()
    exp_terms2.tolist()
    return exp_terms, exp_terms2


def accept_probe(int n_probes,
                 current_energies,
                 current_states,
                 probe_energies,
                 probe_states,
                 prob_accept):
    for i in xrange(n_probes):
        state_energy = current_energies[i]
        probe_energy = probe_energies[i]
        probe = probe_states[i]
        p = prob_accept[i]
        if (probe_energy < state_energy) or (random.uniform(0, 1) < p):
            current_energies[i] = probe_energy
            current_states[i] = probe
    return current_energies, current_states