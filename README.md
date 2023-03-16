# The Disc Shop Datatbase

***The database was designed and made for the educational purposes and representing my SQL skills. The repository contains all the scripts of creation, random text data generation etc.***
___
## The database scheme
![DB_scheme](https://user-images.githubusercontent.com/104217922/225729723-c420a54c-19bf-4f13-aed6-db4861f51b29.png)

## **Additional Database Info**
**OperationLog**: 
  * Operation type (Purchase\Rent) 
  * OperationDateTimeStart (DATETIME) the moment of carrying out the operation (since 2014) 
  * OperationDateTimeEnd (DATETIME) the moment of rent return. In the case of purchase or rent when the disc wasn't returned the value is NULL

**Client**: 
  * Child (1 or 0) 
  * MariedStatus (1 or 0)
  * Sex (1 or 0)

**PersonalDiscount**:   
Personal client's discount. 0 in default. As the profit from the client reaches out 5000 UAH PersonalDiscount will get 5%. 15000 UAH - 10%, 30000 UAH - 15%, 50000 UAH - 20%. When the client has a debt the discount doean't work out. In case when the debt hasn't been repayed the client goes down one level of the discounts.    
**Rent: 1 month. The rent price is 50% of purhcase price**
___
## **Files**
+ **Creation.sql**: *Contains scripts of tables' creation*
+ **Data Generation.sql**: *Contains script of random test data generation*
+ **Database Backup.sql**: *Contains script of backing up the database*
+ **Triggers**
  + **Trigger OperationLog INSERT.sql**: *Contsains script of creating the trigger for OperationLog table after the INSERT command which should add the new data to PersonalDiscount*
+ **Views**
  + **Debtors.sql**: *The list of debtors and the period of indebtedness*
  + **Favourite Artist By Favourite Actor.sql**: *The favorite music artists of the clients who are unmarried males with children and whose favorite actor is Jackie Chan.  
**Note: favorite in this context means discs with whome the client has bought the most***
  + **Not Touched Discs.sql**: *The discs which haven't been bought or rented by anyone*
  + **Post Domen.sql**: *Post domens of clients with Kyivstar operator SIM, Aries zodiac sign, whose favorite genre of music is rock and the favorite ganre of films is action, and who aren't currently in debt*
  + **Quartal Income.sql**: *Incom for each quartal of each year*
  + **Profit from Each Client per Year.sql**: *Profit from each customer from renting and buying discs with music and films in the format: Client's name | Year | Renting of films | Renting music | Buying films | byuing music.*
+ **Procedures**
  + **Raise Or Lower Discount.sql**: *Change the level of discount for a certain client*
  + **Raise Or Lower.sql**: *Inclines the prices for each disc in a certain category (music or films)*