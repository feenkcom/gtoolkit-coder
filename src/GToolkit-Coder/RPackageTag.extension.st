Extension { #name : 'RPackageTag' }

{ #category : '*GToolkit-Coder' }
RPackageTag >> gtClassesCoderFor: aView context: aPhlowContext [
	<gtPackageTagView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageTagCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Classes';
		disableAsync;
		stencil: [ aPhlowContext packageTagCoder classesCoder asElement ]
]
