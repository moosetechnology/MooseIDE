Extension { #name : #MooseEntity }

{ #category : #'*MooseIDE-Core' }
MooseEntity >> midasIcon [
	^ self mooseIcon
]

{ #category : #'*MooseIDE-Core' }
MooseEntity >> mooseIcon [
	^ self iconNamed: #mooseMetamodelEntity
]
