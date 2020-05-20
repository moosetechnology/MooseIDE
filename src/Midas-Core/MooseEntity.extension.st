Extension { #name : #MooseEntity }

{ #category : #'*Midas-Core' }
MooseEntity >> isMooseEntity [
	^ true
]

{ #category : #'*Midas-Core' }
MooseEntity >> midasIcon [
	^ self iconNamed: #mooseMetamodelEntity
]
