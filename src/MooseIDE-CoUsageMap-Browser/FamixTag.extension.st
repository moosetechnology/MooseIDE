Extension { #name : #FamixTag }

{ #category : #'*MooseIDE-CoUsageMap-Browser' }
FamixTag >> addReference: aMiCoTaggedObject [
	| tagAssociation tags entity |
	tags := aMiCoTaggedObject rawObject allTagAssociations 
		select: [ :asso | asso tag = self ].
	tags ifNotEmpty: [ ^ self ].
	entity := aMiCoTaggedObject rawObject.
	tagAssociation := FamixTagEntityAssociation newForEntity: entity tag: self.
	aMiCoTaggedObject application 
		ifNotNil: [ :app | app consumeItem: tagAssociation ]
]

{ #category : #'*MooseIDE-CoUsageMap-Browser' }
FamixTag >> asMiCoTag [
	"self flag: 'TODO'.
	^ MiCoTag new
		name: self name;
		color: self color;
		description: self description;
		yourself
		"
	^ self
]

{ #category : #'*MooseIDE-CoUsageMap-Browser' }
FamixTag >> removeReference: aMiCoTaggedObject [
	| tagAssociation app |
	tagAssociation := aMiCoTaggedObject rawObject allTagAssociations 
		detect: [ :assoc | assoc tag = self ]
		ifNone: [ nil ].
	
	app := aMiCoTaggedObject application.
	(app notNil and: [ tagAssociation notNil ]) ifTrue: [
		app removeItem: tagAssociation ].
	
	aMiCoTaggedObject rawObject removeTag: self.
]
