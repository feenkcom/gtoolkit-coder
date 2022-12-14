Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtAllowedDependenciesFor: aView [
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
RPackage >> gtBaselinesFor: aView [
	<gtPackageView>
	^ aView forward
		title: 'References';
		tooltip: 'References to the package name';
		priority: 30;
		object: [ self name gtStringLiteralCaseSensitiveMatch | self name gtReferences ];
		view: #gtItemsFor:
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowse [
	^ ((GtCoder forPackage: self) 
		openInPager) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtBrowseFrom: anElement [
	^ ((GtCoder forPackage: self) asElement openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
RPackage >> gtDefinedClassesFor: aView context: aPhlowContext [
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
