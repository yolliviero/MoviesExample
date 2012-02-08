/*
Copyright (c) 2011 Ulf Björklund, http://average-uffe.blogspot.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using MoviesExample.Core.Model;
	using MoviesExample.Core.Interfaces.Data;
	
namespace MoviesExample.Data
{
    /// <summary>
    /// An abstract baseclass handling basic CRUD operations against the context.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class BaseRepository<T> : IDisposable, IRepository<T> where T : PersistentEntity
    {
        private IDataContext _context;
        private readonly IDbSet<T> _dbset;
        private readonly IDatabaseFactory _databaseFactory;

        protected BaseRepository(IDatabaseFactory databaseFactory)
        {
            this._databaseFactory = databaseFactory;
            this._context = this._databaseFactory.Get();
            this._dbset = this.DataContext.DbSet<T>();
        }

        public IDataContext DataContext
        {
            get { return this._context ?? (this._context = this._databaseFactory.Get()); }
        }

        /// <summary>
        /// The name of the Generic entity using the repository.
        /// Used for smoother queries.
        /// </summary>
        protected string EntitySetName { get; set; }

        /// <summary>
        /// Saves a new entity of T or updates an in the context existing entity (if it´s changed).
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual void SaveOrUpdate(T entity)
        {
            if (UnitOfWork.IsPersistent(entity))
            {
                this.DataContext.Entry(entity).State = EntityState.Modified;
            }
            else
                this._dbset.Add(entity);
        }

        /// <summary>
        /// Get one entity of T
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public virtual T GetById(int id)
        {
            return this._dbset.Find(id);
        }

        /// <summary>
        /// Get all entities of T
        /// </summary>
        /// <returns></returns>
        public virtual IQueryable<T> GetAll()
        {
            return this._dbset;
        }

        /// <summary>
        /// Get all entities of T without tracking
        /// </summary>
        /// <returns></returns>
        public virtual IQueryable<T> GetAllReadOnly()
        {
            return this._dbset.AsNoTracking();
        }

        /// <summary>
        /// Removes an entity T from the context and persist the change.
        /// </summary>
        /// <param name="entity"></param>
        public virtual void Delete(T entity)
        {
            this._dbset.Remove(entity);
        }

        /// <summary>
        /// The LinqExpression will give us the opportunity to write strongly typed object queries to this methodsignature.
        /// </summary>
        /// <param name="expression"></param>
        /// <param name="maxHits"></param>
        /// <returns></returns>
        public virtual IEnumerable<T> Find(System.Linq.Expressions.Expression<Func<T, bool>> expression, int maxHits = 100)
        {
            return this._dbset.Where(expression).Take(maxHits);
        }

        public void Dispose()
        {
            this.DataContext.ObjectContext().Dispose();
        }
    }
}