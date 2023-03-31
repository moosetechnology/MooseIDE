"
Utility class to customize a composite shape from roassal
"
Class {
	#name : #MiCoContainerShape,
	#superclass : #RSComposite,
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoContainerShape >> color: aColor [
	self children size > 1 
		ifTrue: [ self children second color: aColor ]
		ifFalse: [ super color: aColor ]
]

{ #category : #accessing }
MiCoContainerShape >> innerBoxShapes [
	^ self children second children
]
