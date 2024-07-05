"
TODO
"
Class {
	#name : #RSLineResult,
	#superclass : #Object,
	#instVars : [
		'lineNumber',
		'line',
		'point',
		'start',
		'end',
		'index'
	],
	#category : #'MooseIDE-AttributedText'
}

{ #category : #accessing }
RSLineResult >> end [

	^ end
]

{ #category : #accessing }
RSLineResult >> end: anObject [

	end := anObject
]

{ #category : #accessing }
RSLineResult >> index [

	^ index
]

{ #category : #accessing }
RSLineResult >> index: anObject [

	index := anObject
]

{ #category : #accessing }
RSLineResult >> line [

	^ line
]

{ #category : #accessing }
RSLineResult >> line: anObject [

	line := anObject
]

{ #category : #accessing }
RSLineResult >> lineNumber [

	^ lineNumber
]

{ #category : #accessing }
RSLineResult >> lineNumber: anObject [

	lineNumber := anObject
]

{ #category : #accessing }
RSLineResult >> point [

	^ point
]

{ #category : #accessing }
RSLineResult >> point: anObject [

	point := anObject
]

{ #category : #accessing }
RSLineResult >> start [

	^ start
]

{ #category : #accessing }
RSLineResult >> start: anObject [

	start := anObject
]
