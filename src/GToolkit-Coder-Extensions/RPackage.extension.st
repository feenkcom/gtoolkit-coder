Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBaselinesFor: aView [
	<gtPackageView>
	^ aView explicit
		title: 'References';
		priority: 30;
		stencil: [ self name gtStringLiteralCaseSensitiveMatch ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowse [
	^ ((GtCoder forPackage: self) 
		openInPager) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowseFrom: anElement [
	^ ((GtCoder forPackage: self) 
		openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtDefinedClassesFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Classes';
		disableAsync;
		stencil: [ aPhlowContext packageCoder classesCoder asElement ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtDefinedTagsFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10.5;
		title: 'Tags';
		disableAsync;
		stencil: [ 
			BrSimpleList new
				itemStencil: [ GtPackageTagCardElement new ];
				itemDataBinder: [ :eachTagCard :eachTagCoder | 
					eachTagCard coder: eachTagCoder ];
				items: (aPhlowContext packageCoder packageTagsCoder coders
					asSortedCollection: [ :a :b | a packageTagName < b packageTagName ]);
				addEventFilterOn: BlClickEvent do: [ :anEvent | anEvent currentTarget requestFocus ] ]
]
