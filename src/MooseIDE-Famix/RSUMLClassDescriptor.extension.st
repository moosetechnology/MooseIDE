Extension { #name : #RSUMLClassDescriptor }

{ #category : #'*MooseIDE-Famix' }
RSUMLClassDescriptor >> forFamix [

	self
		classname: #name;
		superclass: #superclass;
		instVars: [ :type | type attributes sorted: #name ascending ];
		methods: [ :type | type methods sorted: #name ascending ];
		methodSelector: #name;
		instVarSelector: #name;
		methodsLimit: SmallInteger maxVal;
		isAbstract: [ :cls | cls isAbstract ifNil: [ false ] ]
]
