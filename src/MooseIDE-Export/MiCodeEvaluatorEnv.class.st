"
I am an environment, storing globals and useful methods accessible in code blocks. I am used as the receiver of a microdown code block (with argument eval=ture) execution.
"
Class {
	#name : #MiCodeEvaluatorEnv,
	#superclass : #MicCodeblockEvaluatorEnv,
	#instVars : [
		'entities',
		'printer',
		'globals'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #initialization }
MiCodeEvaluatorEnv >> addGlobal: anAssoc [
	
	globals at: anAssoc key put: anAssoc value
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> entities [

	^ entities
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> entities: anObject [

	entities := anObject
]

{ #category : #initialization }
MiCodeEvaluatorEnv >> getGlobal: aString [

	^ globals at: aString ifAbsent: [ nil ]
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> globals [

	^ globals
]

{ #category : #initialization }
MiCodeEvaluatorEnv >> initialize [

	super initialize.
	printer := MiReportCollectionPrinter new.
	globals := Dictionary new
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> rootClass: aMooseEntity [

	| pt |
	( aMooseEntity isMethod not and:[aMooseEntity isClass not and: [ aMooseEntity isPackage ]]) ifTrue: [ ^ nil ].
	pt := aMooseEntity parents anyOne.
	((aMooseEntity isType) and: [pt isClass not and: [ pt isPackage ]]) ifTrue: [ 
		^ aMooseEntity ].
	^ self rootClass: pt
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> stream [

	^ stream
]

{ #category : #accessing }
MiCodeEvaluatorEnv >> stream: anObject [

	stream := anObject.
	printer stream: stream
]
