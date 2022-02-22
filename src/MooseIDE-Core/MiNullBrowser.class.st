"
I am a Null browser doing nothing and showing nothing.
I can be used where a MiAbstractBrowser is expected
"
Class {
	#name : #MiNullBrowser,
	#superclass : #MiAbstractBrowser2,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiNullBrowser class >> defaultSpec [ 
	^super defaultSpec 
		add: ('I am a ' , self name) ;
		yourself
]

{ #category : #accessing }
MiNullBrowser class >> title [ 
	^'Empty browser'
]

{ #category : #testing }
MiNullBrowser >> canEditBuses [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canFollow [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canFollowEntity: anObject [

	^ false
]

{ #category : #testing }
MiNullBrowser >> canPropagate [

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
