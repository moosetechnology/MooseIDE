Class {
	#name : 'FamixCBModel',
	#superclass : 'MooseModel',
	#traits : 'FamixCBTEntityCreator',
	#classTraits : 'FamixCBTEntityCreator classTrait',
	#category : 'Famix-CriticBrowser-Entities-Model',
	#package : 'Famix-CriticBrowser-Entities',
	#tag : 'Model'
}

{ #category : 'accessing' }
FamixCBModel class >> allSubmetamodelsPackagesNames [

	<ignoreForCoverage>
	<generated>
	^ #(#'Moose-Query' #'Moose-Core' #'Famix-Traits')
]

{ #category : 'meta' }
FamixCBModel class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Model super: #MooseModel>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
]
