Extension { #name : 'MooseModel' }

{ #category : '*MooseIDE-Meta' }
MooseModel class >> possibleModelsToImportFromFiles [

	^ self withAllSubclasses reject: [ :model | model isDeprecated or: [ model canBeImportedFromFile not ] ]
]
