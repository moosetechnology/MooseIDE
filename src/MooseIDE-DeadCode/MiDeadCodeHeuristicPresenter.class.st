"
A LabelPresenter specialized for DeadCodeHeuristics

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
MiDeadCodeHeuristicPresenter >> heuristic [

	^ heuristic
]

{ #category : 'accessing' }
MiDeadCodeHeuristicPresenter >> heuristic: aDeadCodeHeuristic [

	heuristic := aDeadCodeHeuristic.

	self label: heuristic name.
	self help: heuristic description
]
