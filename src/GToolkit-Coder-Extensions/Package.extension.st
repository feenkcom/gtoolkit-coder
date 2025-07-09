Extension { #name : #Package }

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtAllowedDependenciesFor: aView [
	<gtPackageView>
	(self packageManifestOrNil
		ifNil: [ false ]
		ifNotNil:  [ :aPackage | 
			aPackage class canPerform: #mustOnlyDependOn ]) ifFalse: [ ^ aView empty ] .
					
	^ aView list
		title: 'Allowed Dependencies';
		priority: 50;
		items: [ 
			self packageManifestOrNil
				ifNil: [ #() ]
				ifNotNil:  [ :aPackage | 
					(aPackage class canPerform: #mustOnlyDependOn)
						ifTrue: [ aPackage mustOnlyDependOn collect: #asPackage ]
						ifFalse: [ #() ] ] ];
		itemText: [ :aPackage | aPackage name ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtBaselinesFor: aView [
	<gtView>
	<gtPackageView>
	^ aView forward
		title: 'References';
		tooltip: 'References to the package name';
		priority: 30;
		object: [ self name gtStringLiteralCaseSensitiveMatch | self name gtReferences ];
		view: #gtItemsFor:
]

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtBrowse [
	^ ((GtCoderElement forPackage: self) 
		openInPager) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtBrowseFrom: anElement [
	^ ((GtCoderElement forPackage: self) asElement openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtDefinedClassesFor: aView context: aPhlowContext [
	<gtPackageView>
	(aPhlowContext isKindOf: GtPhlowExecutionContext) ifFalse: [ ^ aView empty ].
	aPhlowContext hasPackageCoder ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 1;
		title: 'Classes';
		disableAsync;
		stencil: [ aPhlowContext packageCoder classesCoder asElement ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
Package >> gtDefinedTagsFor: aView context: aPhlowContext [
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
