"
A LabelPresenter specialized for DeadCodeHeuristics
It may contain/present:
- a group of heuristics represented by an association: 'group-name' -> 'list-of-heuristics'
- a single heuristic

The #name and the #help are set from internal the `MiDeadCodeAbstractHeuristic`
"
Class {
	#name : 'MiDeadRulePresenter',
	#superclass : 'SpLabelPresenter',
	#instVars : [
		'rule'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'instance creation' }
MiDeadRulePresenter class >> withRule: aDeadCodeHeuristic [

	^self new
		rule: aDeadCodeHeuristic
]

{ #category : 'api' }
MiDeadRulePresenter >> help [

	^rule isAssociation
		ifTrue: [ 'A collection of heuristics for ' , rule key ]
		ifFalse: [ rule description ]
]

{ #category : 'api' }
MiDeadRulePresenter >> label [

	^rule isAssociation
		ifTrue: [ rule key ]
		ifFalse: [ rule name ]
]

{ #category : 'accessing' }
MiDeadRulePresenter >> rule [

	^ rule
]

{ #category : 'accessing' }
MiDeadRulePresenter >> rule: aRule [

	rule := aRule
]
