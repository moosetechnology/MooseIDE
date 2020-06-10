Extension { #name : #MooseAbstractGroup }

{ #category : #'*Midas-FamixQueries' }
MooseAbstractGroup >> details [
	^ String
		streamContents: [ :s | 
			| typeName |
			typeName := self entities commonSuperclass mooseDescription name.
			s
				print: self size;
				space.
			self
				ifEmpty: [ s << 'entities' ]
				ifNotEmpty: [ s
						<<
							(self size > 1
								ifTrue: [ typeName asEnglishPlural ]
								ifFalse: [ typeName ]) ] ]
]
