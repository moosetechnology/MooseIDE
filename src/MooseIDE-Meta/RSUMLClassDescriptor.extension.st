Extension { #name : #RSUMLClassDescriptor }

{ #category : #'*MooseIDE-Meta' }
RSUMLClassDescriptor >> forFame [

	self
		classname: #name;
		superclass: [ :metaConcept | 
			metaConcept isFM3Class
				ifTrue: [ metaConcept superclass ]
				ifFalse: [ '' ] ];
		instVars: [ :type | 
			type primitiveProperties sorted: #name ascending ];
		methods: [ :type | type complexProperties sorted: #name ascending ];
		methodSelector: #name;
		instVarSelector: #name;
		methodsLimit: SmallInteger maxVal;
		isAbstract: [ :cls | cls isFM3Trait ifNil: [ false ] ]
]
