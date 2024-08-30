Extension { #name : #MiApplication }

{ #category : #'*MooseIDE-NewTools' }
MiApplication >> addSharedBinding: aBinding [
	
	self sharedBindings add: aBinding
]

{ #category : #'*MooseIDE-NewTools' }
MiApplication >> removeSharedBinding: aBinding [

	self sharedBindings removeKey: aBinding key
]

{ #category : #'*MooseIDE-NewTools' }
MiApplication >> sharedBindings [
	"bindings that are shared by all playgrounds"

	^ self propertyAt: #sharedBindings ifAbsentPut: [ Dictionary new ]
]
