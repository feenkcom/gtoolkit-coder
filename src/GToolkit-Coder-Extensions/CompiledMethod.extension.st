Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ (GtCoderElement forMethod: self) 
			openInPager
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtCoderElement forMethod: self) asElement openInPagerFrom: anElement) maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtDisplayOn: aStream [
	aStream print: self methodClass; nextPutAll: '>>'; store: self selector.
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersionsFor: aView [
	<gtView>
	
	self sourcePointer ifNil: [ ^ aView empty ].
	
	^ aView list
		title: 'Local versions';
		priority: 10;
		items: [ 
			| changeRecords |
			changeRecords := SourceFiles
				changeRecordsFrom: self sourcePointer
				className: self methodClass instanceSide name
				isMeta: self methodClass isMeta.
			changeRecords withIndexCollect: [ :aChange :anIndex |
				 GtLocalVersion 
					change: aChange 
					previousChange: (changeRecords at: anIndex + 1 ifAbsent: [nil])
					currentMethod: self ] ];
		itemStencil: [ GtLocalVersionElement new ];
		itemDataBinder: [ :aLocalVersionElement :aLocalVersion | 
				aLocalVersionElement
					localVersion: aLocalVersion ]
]
