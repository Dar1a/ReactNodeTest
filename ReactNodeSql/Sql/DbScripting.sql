
IF OBJECT_ID(N'dbo.Product', N'U') IS NULL 
BEGIN 
CREATE TABLE dbo.Product(
ProductId int  IDENTITY (1,1) NOT NULL,
ProductName  varchar (250) NOT NULL,
ProductType varchar(10) NOT NULL,
ProductDescription varchar(300) NULL,
CONSTRAINT PK_Product PRIMARY KEY (ProductId ASC),--- dafault Clustred index
CONSTRAINT CHK_Product CHECK (ProductType in ('Book', 'Toy', 'Clothes')),
CONSTRAINT UQC_Product UNIQUE (ProductName)
)
 END
GO

INSERT INTO dbo.Product(ProductName,ProductType,ProductDescription)
VALUES ('shirt','Clothes','eqwr'),
		('Car','Toy',''),
		('boots','Clothes',''),
		('Wiki','Book',''),
		('Tutorial MSSQL server 2008R2','Book','')

GO


IF OBJECT_ID(N'dbo.Stores', N'U') IS NULL 
BEGIN 
CREATE TABLE dbo.Stores(
StoreId int  IDENTITY (1,1) NOT NULL,
StoreName  varchar (50) NOT NULL,
City varchar(250) NULL,
CONSTRAINT PK_Stores PRIMARY KEY  (StoreId Asc),
CONSTRAINT UQK_Store UNIQUE  (StoreName)
)

END
GO


INSERT INTO dbo.Stores (StoreName, City)
VALUES('Apple store', 'NY'),
	 ('Helen Marlen', 'Brooklin'),
	 ('H&M', 'Kiev'),
	 ('Aldo', 'Kharkov'),
	 ('Ashuan', 'Sumy')

GO 


IF OBJECT_ID(N'dbo.SalePrice', N'U') IS NULL 
BEGIN
CREATE TABLE dbo.SalePrice (

 ProductId INT NOT NULL,
 StoreId INT NOT NULL,
 Price  DECIMAL(10,5) NOT NULL
 CONSTRAINT PK_SalePrice PRIMARY KEY ClUSTERED (ProductId asc, StoreId asc)

)
END 
GO 


insert into SalePrice(ProductId,StoreId,Price)

select p.ProductId ,s.StoreId , cast (RAND(
                CAST( NEWID() AS varbinary )) as decimal (10,5)) as Price 
from dbo.Stores s
	CROSS JOIN dbo.Product p

go

iF OBJECT_ID ('dbo.GetProducts', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.GetProducts'
	EXEC ('CREATE PROCEDURE dbo.GetProducts  @ProductId INT = NULL AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.GetProducts')
 GO

 ALTER PROCEDURE dbo.GetProducts  
	@ProductId INT = NULL
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			
			SELECT ProductName,
			    ProductId,
				ProductType,
				ProductDescription 
			FROM dbo.Product
			WHERE @ProductId Is null OR @ProductId=ProductID
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go

iF OBJECT_ID ('dbo.GetStores', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.GetStores'
	EXEC ('CREATE PROCEDURE dbo.GetStores
			@StoreId INT  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.GetStores')
 GO

 ALTER PROCEDURE dbo.GetStores
	@StoreId INT = NULL 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			


	SELECT StoreName,
		   StoreId,
		   City 
	FROM dbo.Stores   
	WHERE @StoreId IS NULL OR StoreID = @StoreId  
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go

 iF OBJECT_ID ('dbo.GetSalePrice', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.GetSalePrice'
	EXEC ('CREATE PROCEDURE dbo.GetSalePrice
			@StoreId INT = NULL,
			@ProductID INT = NULL  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.GetSalePrice')
 GO

 ALTER PROCEDURE dbo.GetSalePrice
	@StoreId INT = NULL,
	@ProductId INT = NULL 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			


	SELECT s.StoreName,
		   s.StoreId,
		   p.ProductName,
		   p.ProductId,
		   sp.Price
	FROM dbo.SalePrice sp  
	 INNER JOIN dbo.Product p ON p.ProductId = sp.ProductId
	 INNER JOIN dbo.Stores s ON s.StoreId = sp.StoreId
	 WHERE( @StoreId IS NULL OR sp.StoreID = @StoreId)
		  AND (@ProductId IS NULL OR @ProductId = sp.ProductId )
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go



 iF OBJECT_ID ('dbo.UpdateProducts', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.UpdateProducts'
	EXEC ('CREATE PROCEDURE dbo.UpdateProducts  
			@ProductId INT 
		   ,@ProductName VARCHAR(250) = NULL
		   ,@ProductType VARCHAR(10) = NULL
		   ,@ProductDescription VARCHAR(300) = NULL  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.UpdateProducts')
 GO

 ALTER PROCEDURE dbo.UpdateProducts  
	@ProductId INT 
   ,@ProductName VARCHAR(250) 
   ,@ProductType VARCHAR(10) 
   ,@ProductDescription VARCHAR(300) = NULL
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			
	IF @ProductName = ''
	 RAISERROR ('ProductName cannot be empty', 16,1 , @ProductId)		 

	 UPDATE  dbo.Product
	 SET ProductName = ISNULL(@ProductName, ProductName),
		 ProductType = ISNULL(@ProductType,ProductType),
		 ProductDescription = ISNULL(@ProductDescription, ProductDescription)
	FROM dbo.Product   
	WHERE ProductId = @ProductId  
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go

iF OBJECT_ID ('dbo.UpdateStores', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.UpdateStores'
	EXEC ('CREATE PROCEDURE dbo.UpdateStores
			@StoreId INT,
			@StoreName VARCHAR(250) = NULL,
			@StoreDescription VARCHAR(10)  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.UpdateStores')
 GO

 ALTER PROCEDURE dbo.UpdateStores
	@StoreId INT ,
	@StoreName VARCHAR(250) ,
	@City VARCHAR(10) 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
	
			
  IF @StoreName = ''
	RAISERROR ('StoreName cannot be empty',16,1);

	IF @City = ''
	RAISERROR ('City cannot be empty',16,1);

  UPDATE dbo.Stores 
  SET StoreName = ISNULL( @StoreName,StoreName),
  	  City = ISNULL(@City, City)
  WHERE StoreId = @StoreId
	

			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go


 iF OBJECT_ID ('dbo.InsertProducts', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.InsertProducts'
	EXEC ('CREATE PROCEDURE dbo.InsertProducts  
			@ProductName VARCHAR (250),
			@ProductType VARCHAR(10),
			@ProductDescription VARCHAR(300)   AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.InsertProducts')
 GO

 ALTER PROCEDURE dbo.InsertProducts  
	@ProductType VARCHAR(10) ,
	@ProductName VARCHAR (250) ,
	@ProductDescription VARCHAR(300) = NULL
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			
	IF @ProductName = ''
	 RAISERROR ('ProductName can not be empty', 16,1);		
	 
	 
	  

INSERT INTO dbo.Product(ProductName, ProductType,ProductDescription)
 values (@ProductName,@ProductType, @ProductDescription)
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go


 iF OBJECT_ID ('dbo.InsertStores', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.InsertStores'
	EXEC ('CREATE PROCEDURE dbo.InsertStores
			@StoreName varchar(250),
			@StoreDescription varchar(10)  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.InsertStores')
 GO

 ALTER PROCEDURE dbo.InsertStores
	@StoreName varchar(250),
	@City VARCHAR(10) 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			
  IF @StoreName = ''
	RAISERROR ('StoreName can not be empty',16,1);

  IF @City = ''
	RAISERROR ('City can not be empty',16,1);


	INSERT INTO dbo.Stores(StoreName, City)
	VALUES(@StoreName,@City)


			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go

 iF OBJECT_ID ('dbo.ManageSalePrice', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.ManageSalePrice'
	EXEC ('CREATE PROCEDURE dbo.ManageSalePrice
			--@IsInsert BIT,
			@SalePriceXML XML  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.ManageSalePrice')
 GO

 ALTER PROCEDURE dbo.ManageSalePrice  
	--@IsInsert BIT,
	@SalePriceXML XML
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
	
 --'<SalePrice>
		--	<Key ProductId = "3" StoreId = "5" Price = "0.777777" />'
--	</SalePrice>

					 
	DECLARE @Idoc INT ,
			@ValidationMessage varchar(255)

	 IF OBJECT_ID ('tempDB..#SalePrice') IS NOT NULL DROP TABLE #SalePrice 

	 CREATE TABLE #SalePrice 
	 (Id INT IDENTITY (1,1) NOT NULL,
	  ProductId INT ,
	  StoreId INT,
	  Price DECIMAL (10,5),
	  ValidationError TINYINT
	 )

	EXEC sp_xml_preparedocument @Idoc OUTPUT, @SalePriceXML	
	
	INSERT INTO #SalePrice(
			ProductId,
			StoreId,
			Price	)

	SELECT ProductId,
			StoreId,
			Price				 
	FROM 
		OPENXML(@idoc, '/SalePrice/Key', 1)		 
	WITH 
	 (ProductId INT ,
	  StoreId INT,
	  Price DECIMAL (10,5))
	  
	  	
	  UPDATE t  SET t.ValidationError = tt.ValidationError 
	  FROM   #SalePrice t
	  INNER JOIN (
		SELECT id,	MAX(rules) AS ValidationError FROM(
		SELECT sp.ID,
			CASE WHEN p.ProductId IS NULL THEN 1 ELSE 0 END IncorrectProductId,
			CASE WHEN s.StoreId IS NULL THEN 2 ELSE 0 END IncorrectStoreId,
			CASE WHEN isnull(sp.Price, 0) = 0 THEN 3 ELSE 0 END EmptyPrice
		FROM #SalePrice sp
			LEFT JOIN dbo.Product p on p.ProductId = sp.ProductId 
			LEFT JOIN dbo.Stores s on s.StoreId = sp.StoreId) p 
			unpivot (rules for ruleID in (IncorrectProductId,
											IncorrectStoreId,
											EmptyPrice)) unpv
		GROUP BY ID ) tt on tt.Id = t.id

		IF EXISTS (select * from #SalePrice where ValidationError >0)
		BEGIN 
			select @ValidationMessage = 
			(Case when ValidationError =1 then  'Incorrect ProductId ' 
			      when ValidationError = 2 then 'Incorrect StoreID'
				  when ValidationError =3 THEN 'Not valid Price - 0.0 or emty'
			else '' end)
			From #SalePrice where ValidationError > 0 

		RAISERROR ('Please check xml because key columns are not coresponed to business rules: %s', 16, 1, @ValidationMessage)
		END


		;MERGE dbo.SalePrice  as target 
		USING (
		SELECT ProductId ,
			StoreId,
			Price 
		FROM #SalePrice
		) AS SOURCE 
		ON  target.ProductID = source.ProductId
			and target.StoreId = source.StoreId 
		WHEN MATCHED THEN --AND @IsInsert = 0  
		UPDATE 
			SET Target.Price = Source.Price
		WHEN NOT MATCHED THEN  --AND @IsInsert =1 
		INSERT (ProductId,
				StoreId, 
				Price )
		VALUES (
		SOURCE.ProductId,
		SOURCE.StoreId,
		SOURCE.Price);

 END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go



iF OBJECT_ID ('dbo.DeleteProducts', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.DeleteProducts'
	EXEC ('CREATE PROCEDURE dbo.DeleteProducts  
			@ProductId INT  AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.DeleteProducts')
 GO

 ALTER PROCEDURE dbo.DeleteProducts  
	@ProductId INT 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
					 
	
	DELETE 
	FROM dbo.SalePrice 
	WHERE ProductId = @ProductId

	DELETE 
	FROM dbo.Product   
    WHERE ProductId = @ProductId  
			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go



iF OBJECT_ID ('dbo.DeleteStores', 'P') IS NULL
 BEGIN 
	PRINT 'Creaing dbo.DeleteStores'
	EXEC ('CREATE PROCEDURE dbo.DeleteStores
			@StoreId INT AS 
		BEGIN return END ')
 END 
 GO
	PRINT ('ALTER PROCERURE dbo.DeleteStores')
 GO

 ALTER PROCEDURE dbo.DeleteStores
	@StoreId INT 
 AS 
 SET NOCOUNT ON 
   BEGIN TRY 
			
	
	DELETE FROM dbo.SalePrice WHERE StoreId = @StoreId

	DELETE FROM dbo.Stores where StoreId = @StoreId
	

			 
			 
   END TRY 
 BEGIN CATCH 
	declare 
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorProcedure NVARCHAR(126) = ERROR_PROCEDURE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorMessage NVARCHAR(2048) = OBJECT_NAME(@@PROCID) + ':' + ERROR_MESSAGE()
	
	IF (XACT_STATE() = -1 )
	ROLLBACK 
	--EXEC  dbo.LogError

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorProcedure , @ErrorLine)
  END CATCH 

 go


 
