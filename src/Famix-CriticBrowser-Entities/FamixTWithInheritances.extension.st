Extension { #name : #FamixTWithInheritances }

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixTWithInheritances >> inheritsFromClassNamed: aString [
	self allSuperclassesDo: [ :each | each name = aString ifTrue: [ ^ true ] ].
	^ false
]
