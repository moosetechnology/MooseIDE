"
A LabelPresenter specialized for DeadCodeHeuristics
It may contain/present:
- a group of heuristics represented by an association: 'group-name' -> 'list-of-heuristics'
- a single heuristic

The #name and the #help are set from internal the `MiDeadCodeAbstractHeuristic`
"
Class {
	#name : 'MiDeadCodeHeuristicPresenter',
	#superclass : 'SpLabelPresenter',
	#instVars : [
		'heuristic'
	],
	#category : 'MooseIDE-DeadCode-Browser',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Browser'
}

{ #category : 'instance creation' }
MiDeadCodeHeuristicPresenter class >> withHeuristic: aDeadCodeHeuristic [

	^self new
		heuristic: aDeadCodeHeuristic
]

{ #category : 'accessing' }
MiDeadCodeHeuristicPresenter >> children [

	^heuristic isAssociation
		ifTrue: [ heuristic value ]
		ifFalse: [ {  heuristic } ]
]

{ #category : 'api' }
MiDeadCodeHeuristicPresenter >> help [

	^heuristic isAssociation
		ifTrue: [
			heuristic key isString
				ifTrue: [ 'A collection of heuristics for ' , heuristic key ]
				ifFalse: [ heuristic key description ]
		]
		ifFalse: [ heuristic description ]
]

{ #category : 'accessing' }
MiDeadCodeHeuristicPresenter >> heuristic [

	^ heuristic
]

{ #category : 'accessing' }
MiDeadCodeHeuristicPresenter >> heuristic: aDeadCodeHeuristic [

	heuristic := aDeadCodeHeuristic
]

{ #category : 'accessing' }
MiDeadCodeHeuristicPresenter >> heuristicGroup: aHeuristicGroup [

	heuristic := aHeuristicGroup.

	aHeuristicGroup key isString
		ifTrue: [
			self label: aHeuristicGroup key.
			self help: 'A collection of heuristics for: ' , aHeuristicGroup key ]
		ifFalse: [
			self label: aHeuristicGroup key name.
			self help: aHeuristicGroup key description
		]
]

{ #category : 'api' }
MiDeadCodeHeuristicPresenter >> label [

	^heuristic isAssociation
		ifTrue: [
			heuristic key isString
				ifTrue: [ heuristic key ]
				ifFalse: [ heuristic key name ]
		]
		ifFalse: [ heuristic name ]
]
