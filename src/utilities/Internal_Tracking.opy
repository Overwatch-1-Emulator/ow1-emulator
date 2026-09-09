#!mainFile "../main.opy"


playervar temp_shield_pvar
#!defineMember sound_barrier_amount temp_shield_pvar[1]
#!defineMember test_hp temp_shield_pvar[2]

playervar ow1_true_damage


# This is a global tracking system for different types of health pools to add back temp shields/armor
# The purpose of ow1_true_damage is to get the rest of the math for to make eventdamage give back its ow1 value term and with that we
# can start using things like Lucio Beat and Sig Grasp
# DONT MOVE ANYTHING