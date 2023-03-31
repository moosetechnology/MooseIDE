Extension { #name : #FamixTag }

{ #category : #'*MooseIDE-Dependency' }
FamixTag >> isApplicableTo: anEntity [

	^ self taggedEntities anySatisfy: [ :e | e = anEntity ]
]
