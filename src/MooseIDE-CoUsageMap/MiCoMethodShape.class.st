"
Utility class to customize a composite shape from roassal
"
Class {
	#name : #MiCoMethodShape,
	#superclass : #RSComposite,
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoMethodShape >> attributeShapes [
	^ self children second children
]

{ #category : #accessing }
MiCoMethodShape >> color: aColor [
	self children size > 1 
		ifTrue: [ self children second color: aColor ]
		ifFalse: [ super color: aColor ]
]
