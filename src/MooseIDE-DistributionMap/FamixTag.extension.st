Extension { #name : 'FamixTag' }

{ #category : '*MooseIDE-DistributionMap' }
FamixTag >> isApplicableTo: anEntity [

	^ anEntity tags includes: self
]
