"
A LabelPresenter specialized for DeadCodeHeuristics
It may contain/present:
- a group of heuristics represented by an association: 'group-name' -> 'list-of-heuristics'
- a single heuristic

The #name and the #help are set from internal the `MiDeadCodeAbstractHeuristic`
"
Class {
	#name : 'MiDeadCodeRulePresenter',
	#superclass : 'SpLabelPresenter',
	#instVars : [
		'rule'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'instance creation' }
MiDeadCodeRulePresenter class >> withRule: aDeadCodeHeuristic [

	^self new
		rule: aDeadCodeHeuristic
]

{ #category : 'api' }
MiDeadCodeRulePresenter >> help [

	^rule isAssociation
		ifTrue: [ 'A collection of heuristics for ' , rule key ]
		ifFalse: [ rule description ]
]

{ #category : 'api' }
MiDeadCodeRulePresenter >> label [

	^rule isAssociation
		ifTrue: [ rule key ]
		ifFalse: [ rule name ]
]

{ #category : 'accessing' }
MiDeadCodeRulePresenter >> rule [

	^ rule
]

{ #category : 'accessing' }
MiDeadCodeRulePresenter >> rule: aRule [

	rule := aRule
]
