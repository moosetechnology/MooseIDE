Extension { #name : #SettingTreeBuilder }

{ #category : #'*MooseIDE-CoUsageMap' }
SettingTreeBuilder >> miRange: aSymbol [
	^ self nodeClass: MiCoRangeSettingDeclaration name: aSymbol
]
