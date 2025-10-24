Extension { #name : 'FamixTag' }

{ #category : '*MooseIDE-DistributionMap' }
FamixTag >> isApplicableTo: anEntity [

	^ self taggedEntities anySatisfy: [ :e | e = anEntity ]
]
