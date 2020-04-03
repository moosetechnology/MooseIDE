Extension { #name : #RSUMLClassDescriptor }

{ #category : #'*Midas-Famix' }
RSUMLClassDescriptor >> forFamix [
	self
		classname: #name;
		instVars: [:cls | cls attributes ];
		methods: [ :cls | cls methods ];
		superclass: #superclass;
		methodSelector: #name;
		instVarSelector: #name;
		methodsLimit: SmallInteger maxVal.
		
]
