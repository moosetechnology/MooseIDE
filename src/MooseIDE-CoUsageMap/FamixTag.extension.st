Extension { #name : #FamixTag }

{ #category : #'*MooseIDE-CoUsageMap' }
FamixTag >> addReference: aMooseObject [
	| tags |
	tags := aMooseObject allTagAssociations 
		select: [ :asso | asso tag = self ].
	tags ifNotEmpty: [ ^ self ].
	^FamixTagEntityAssociation newForEntity: aMooseObject tag: self.

]

{ #category : #'*MooseIDE-CoUsageMap' }
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

{ #category : #'*MooseIDE-CoUsageMap' }
FamixTag >> removeReference: aMooseObject [
	| tagAssociation app |
	tagAssociation := aMooseObject allTagAssociations 
		detect: [ :assoc | assoc tag = self ]
		ifNone: [ nil ].

	self flag: 'need to tell Application that a tagAssociation was removed'.
	"
	app := aMiCoTaggedObject application.
	(app notNil and: [ tagAssociation notNil ]) ifTrue: [
		app removeItem: tagAssociation ]."
	
	aMooseObject removeTag: self.
]
