"
I am a Null browser doing nothing and showing nothing.
I can be used where a MiAbstractBrowser is expected
"
Class {
	#name : #MiNullBrowser,
	#superclass : #MiAbstractBrowser,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #testing }
MiNullBrowser >> canEditBuses [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canFollow [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canPropagate [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canReceiveEntity: anObject [

	^ false
]

{ #category : #actions }
MiNullBrowser >> followEntity: anEntity [

]

{ #category : #testing }
MiNullBrowser >> miSelectedItem [

	^ nil
]

{ #category : #actions }
MiNullBrowser >> needUpdate: anEntity [
	^false
]
