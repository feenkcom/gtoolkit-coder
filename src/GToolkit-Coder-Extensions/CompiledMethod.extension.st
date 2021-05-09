Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ (GtCoder forMethod: self) 
			openInPager
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtCoder forMethod: self) 
			openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtLocalVersionsFor: aView [
	<gtView>
	^ aView columnedList 
		title: 'Local versions';
		items: [ 
			SourceFiles
				changeRecordsFrom: self sourcePointer
				className: self methodClass
				isMeta: self methodClass isMeta ];
"		column: 'Type' text: #type;"
		column: 'Class' text: [ :each | each methodClassName ];
		column: 'Method' text: [:each | each type == #method 
			ifTrue: [each methodSelector] ifFalse: ['']];
		column: 'Timestamp' text: #timeStamp
]
