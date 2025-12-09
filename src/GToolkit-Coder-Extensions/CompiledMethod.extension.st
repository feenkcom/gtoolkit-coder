Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtMethodCoderTool compiledMethod: self ];
		title: self methodClass name;
		icon: BrGlamorousVectorIcons browse;
		show
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ BlSpace new
		withCommonSettings;
		inPager: [ GtMethodCoderTool compiledMethod: self ];
		title: self methodClass name;
		icon: BrGlamorousVectorIcons browse;
		showFrom: anElement
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtChangeRecords [
	self sourcePointer ifNil: [ ^ #() ].
	
	^ SourceFiles
		changeRecordsFrom: self sourcePointer
		className: self methodClass instanceSide name
		isMeta: self methodClass isMeta
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtDisplayOn: aStream [
	aStream print: self methodClass; nextPutAll: '>>'; store: self selector.
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersions [
	| changeRecords |
	changeRecords := self gtChangeRecords.
	^ changeRecords withIndexCollect: [ :aChange :anIndex |
		 GtLocalVersion 
		change: aChange 
			previousChange: (changeRecords at: anIndex + 1 ifAbsent: [nil])
			currentMethod: self ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersionsFor: aView [
	<gtView>
	
	self sourcePointer ifNil: [ ^ aView empty ].
	
	^ aView list
		title: 'Local versions';
		priority: 10;
		items: [ 
			self gtLocalVersions ];
		itemStencil: [ GtLocalVersionElement new ];
		itemDataBinder: [ :aLocalVersionElement :aLocalVersion | 
				aLocalVersionElement
					localVersion: aLocalVersion ]
]
