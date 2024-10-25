"
This is a modified version of the `RSComposite` to accomodate our new DSM
"
Class {
	#name : #MiRSDSMShape,
	#superclass : #RSComposite,
	#instVars : [
		'weight',
		'viewModel'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #accessing }
MiRSDSMShape >> color: aColor [
	self children first color: aColor
]

{ #category : #initialization }
MiRSDSMShape >> initialize [ 
	super initialize.

	self add: (RSBox new size: 15).
	self add: (RSLabel new fontSize: 5).
	self adjustToChildren

]

{ #category : #accessing }
MiRSDSMShape >> text: aString [
	self children second text: aString
]

{ #category : #accessing }
MiRSDSMShape >> viewModel: aMiDependencyStructuralMatrixBrowserModel [
	viewModel := aMiDependencyStructuralMatrixBrowserModel
]

{ #category : #accessing }
MiRSDSMShape >> weight [

	^ weight
]

{ #category : #accessing }
MiRSDSMShape >> weight: anObject [

	weight := anObject
]
