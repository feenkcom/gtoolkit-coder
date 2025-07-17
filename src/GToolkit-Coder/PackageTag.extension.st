Extension { #name : #PackageTag }

{ #category : #'*GToolkit-Coder' }
PackageTag >> gtClassesCoderFor: aView context: aPhlowContext [
	<gtPackageTagView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageTagCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Classes';
		disableAsync;
		stencil: [ aPhlowContext packageTagCoder classesCoder asElement ]
]

{ #category : #'*GToolkit-Coder' }
PackageTag >> gtTagName [
	^ self name
]
