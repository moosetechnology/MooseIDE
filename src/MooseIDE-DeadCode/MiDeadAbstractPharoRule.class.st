"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadAbstractPharoRule',
	#superclass : 'MiDeadAbstractRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadAbstractPharoRule class >> heuristicGroups [

	^#( Java ) , super heuristicGroups
]

{ #category : 'accessing' }
MiDeadAbstractPharoRule >> description [

	^super description ,
	'Pharo: '
]

{ #category : 'accessing' }
MiDeadAbstractPharoRule >> name [

	^'Pharo: '
]

{ #category : 'accessing' }
MiDeadAbstractPharoRule >> ruleGroup [

	^#Pharo
]
