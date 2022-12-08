Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ (GtCoder forMethod: self) 
			openInPager
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtPhlowCoderView new coder: (GtCoder forMethod: self)) asElement
			openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtDisplayOn: aStream [
	aStream print: self methodClass; nextPutAll: '>>'; store: self selector.
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersionsFor: aView [
	<gtView>
	^ aView list
		title: 'Local versions';
		priority: 20;
		items: [ SourceFiles
				changeRecordsFrom: self sourcePointer
				className: self methodClass name
				isMeta: self methodClass isMeta ];
		itemStencil: [ GtLocalVersion new ];
		itemDataBinder: [ :aLocalVersionElement :aLocalVersion | 
				aLocalVersionElement
					compiledMethod: self;
					localVersion: aLocalVersion ]
]
